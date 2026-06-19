#!/bin/bash
# Script para indexar todos os documentos da pasta docs_alfa com dclient

DOCS_FOLDER="./docs_alfa"
ANO="2025"
AUTORES="Autor Sistema"

if [ ! -d "$DOCS_FOLDER" ]; then
    echo "Erro: pasta '$DOCS_FOLDER' não encontrada."
    exit 1
fi

COUNT=0

for file in "$DOCS_FOLDER"/*.txt; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")         # ex: docA.txt
        title="${filename%.*}"              # ex: docA (sem extensão)

        echo "------------------------"
        echo "Ficheiro: $filename"
        echo "Título: $title"
        echo "Ano: $ANO"
        echo "Autores: $AUTORES"

        ./dclient -a "$title" "$AUTORES" "$ANO" "$filename"
        COUNT=$((COUNT + 1))
    fi
done

echo -e "\nIndexados $COUNT documentos do diretório '$DOCS_FOLDER'."
