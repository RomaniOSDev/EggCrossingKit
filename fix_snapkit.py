#!/usr/bin/env python3
import os
import re
import glob

def fix_snapkit_file(file_path):
    """Исправляет SnapKit в одном файле"""
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Удаляем import SnapKit
    content = re.sub(r'import SnapKit\n', '', content)
    
    # Заменяем .snp.makeConstraints на NSLayoutConstraint.activate
    content = re.sub(
        r'(\w+)\.snp\.makeConstraints\s*\{\s*make in\s*\n(.*?)\n\s*\}',
        lambda m: convert_snapkit_constraints(m.group(1), m.group(2)),
        content,
        flags=re.DOTALL
    )
    
    # Заменяем .snp.remakeConstraints
    content = re.sub(
        r'(\w+)\.snp\.remakeConstraints\s*\{\s*make in\s*\n(.*?)\n\s*\}',
        lambda m: convert_snapkit_constraints(m.group(1), m.group(2), remake=True),
        content,
        flags=re.DOTALL
    )
    
    # Заменяем .snp.updateConstraints
    content = re.sub(
        r'(\w+)\.snp\.updateConstraints\s*\{\s*make in\s*\n(.*?)\n\s*\}',
        lambda m: convert_snapkit_constraints(m.group(1), m.group(2), update=True),
        content,
        flags=re.DOTALL
    )
    
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)

def convert_snapkit_constraints(view_name, constraints_text, remake=False, update=False):
    """Конвертирует SnapKit constraints в NSLayoutConstraint"""
    lines = constraints_text.strip().split('\n')
    constraint_lines = []
    
    # Добавляем translatesAutoresizingMaskIntoConstraints = false
    if not remake and not update:
        constraint_lines.append(f'        {view_name}.translatesAutoresizingMaskIntoConstraints = false')
    
    if remake:
        constraint_lines.append(f'        NSLayoutConstraint.deactivate({view_name}.constraints)')
    
    constraint_lines.append('        NSLayoutConstraint.activate([')
    
    for line in lines:
        line = line.strip()
        if not line or line.startswith('//'):
            continue
            
        # Парсим SnapKit constraint
        constraint = parse_snapkit_line(line, view_name)
        if constraint:
            constraint_lines.append(f'            {constraint}')
    
    constraint_lines.append('        ])')
    
    return '\n'.join(constraint_lines)

def parse_snapkit_line(line, view_name):
    """Парсит одну строку SnapKit constraint"""
    # Простые замены для основных случаев
    replacements = {
        'make.edges.equalToSuperview()': f'{view_name}.topAnchor.constraint(equalTo: view.topAnchor),\n            {view_name}.leadingAnchor.constraint(equalTo: view.leadingAnchor),\n            {view_name}.trailingAnchor.constraint(equalTo: view.trailingAnchor),\n            {view_name}.bottomAnchor.constraint(equalTo: view.bottomAnchor)',
        'make.center.equalToSuperview()': f'{view_name}.centerXAnchor.constraint(equalTo: view.centerXAnchor),\n            {view_name}.centerYAnchor.constraint(equalTo: view.centerYAnchor)',
        'make.centerX.equalToSuperview()': f'{view_name}.centerXAnchor.constraint(equalTo: view.centerXAnchor)',
        'make.centerY.equalToSuperview()': f'{view_name}.centerYAnchor.constraint(equalTo: view.centerYAnchor)',
    }
    
    for snapkit, nslayout in replacements.items():
        if snapkit in line:
            return nslayout
    
    return None

def main():
    # Находим все Swift файлы в проекте
    swift_files = glob.glob('EggCrossingKit/**/*.swift', recursive=True)
    
    for file_path in swift_files:
        if 'import SnapKit' in open(file_path, 'r', encoding='utf-8').read():
            print(f'Исправляем {file_path}...')
            fix_snapkit_file(file_path)
    
    print('Готово!')

if __name__ == '__main__':
    main()

