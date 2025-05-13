#!/bin/bash

# Değişkenler (Model, Geçmiş Dosyası, Context ve Prompt Klasörleri)
MODEL="tinyllama"
HISTORY_FILE="./ollama_history.jsonl"
CONTEXT_DIR="./context"
PROMPT_DIR="./prompts"

# Klasörleri oluştur (varsa yoksa)
mkdir -p "$CONTEXT_DIR" "$PROMPT_DIR"

# Soru Sorma (Context'siz)
function ask_question() {
    echo "Sorunuzu giriniz:"
    read -r QUESTION

    echo "Model'e gönderiliyor..."
    RESPONSE=$(echo "$QUESTION" | ollama run "$MODEL")

    echo -e "\n$RESPONSE"
    # Geçmişe kaydet
    echo "{"question": "$QUESTION", "response": "$RESPONSE"}" >> "$HISTORY_FILE"
}

# Soru Sorma (Context ile)
function ask_question_with_context() {
    echo "Sorunuzu giriniz:"
    read -r QUESTION

    # Context'i Python ile al
    CONTEXT=$(python3.10 context_retriever.py "$QUESTION" 0.3)
    FINAL_PROMPT="$CONTEXT"$'\n'"Q: $QUESTION"

    echo "Context ile model'e gönderiliyor..."
    RESPONSE=$(echo "$FINAL_PROMPT" | ollama run "$MODEL")

    echo -e "\n$RESPONSE"
    # Geçmişe kaydet
    echo "{"question": "$QUESTION", "response": "$RESPONSE"}" >> "$HISTORY_FILE"
}

# Geçmişi Görüntüleme
function view_history() {
    echo "=== Sohbet Geçmişi ==="
    cat "$HISTORY_FILE" | jq -r '.question + "\n→ " + .response + "\n---"'
}

# Context Dosyası Ekleme
function add_context_file() {
    echo "Context eklemek istediğiniz dosyanın yolunu giriniz:"
    read -r FILE
    if [[ -f "$FILE" ]]; then
        cp "$FILE" "$CONTEXT_DIR/"
        echo "$FILE context'e eklendi."
    else
        echo "Dosya bulunamadı."
    fi
}

# Menü
function menu() {
    echo "=== Ollama Asistan ==="
    echo "1) Soru sor"
    echo "2) Context ile soru sor"
    echo "3) Geçmişi görüntüle"
    echo "4) Context'e dosya ekle (RAG)"
    echo "5) Çıkış"
}

# Ana Döngü
while true; do
    menu
    read -p "Seçim yapın: " CHOICE
    case "$CHOICE" in
        1) ask_question ;;
        2) ask_question_with_context ;;
        3) view_history ;;
        4) add_context_file ;;
        5) echo "Güle güle!"; exit ;;
        *) echo "Geçersiz seçim." ;;
    esac
done
