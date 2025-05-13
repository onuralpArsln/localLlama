#!/bin/bash

MODEL="llama3"
HISTORY_FILE="./ollama_history.jsonl"
CONTEXT_DIR="./context"
PROMPT_DIR="./prompts"

mkdir -p "$CONTEXT_DIR" "$PROMPT_DIR"

function ask_question() {
    echo "Enter your question:"
    read -r QUESTION

    CONTEXT=$(cat "$CONTEXT_DIR"/* 2>/dev/null)
    FINAL_PROMPT="$CONTEXT"$'\n'"Q: $QUESTION"

    echo "Sending to model..."
    RESPONSE=$(echo "$FINAL_PROMPT" | ollama run "$MODEL")

    echo -e "\n$response"
    
    # Save to history
    echo "{\"question\": \"$QUESTION\", \"response\": \"$RESPONSE\"}" >> "$HISTORY_FILE"
}

function view_history() {
    echo "=== Chat History ==="
    cat "$HISTORY_FILE" | jq -r '.question + "\n→ " + .response + "\n---"'
}

function load_prompt() {
    echo "Available prompts:"
    ls "$PROMPT_DIR"
    echo "Enter prompt filename:"
    read -r PROMPT_NAME
    PROMPT_FILE="$PROMPT_DIR/$PROMPT_NAME"

    if [[ -f "$PROMPT_FILE" ]]; then
        CONTENT=$(cat "$PROMPT_FILE")
        RESPONSE=$(echo "$CONTENT" | ollama run "$MODEL")
        echo -e "\n$response"
        echo "{\"question\": \"(pre-prompt) $PROMPT_NAME\", \"response\": \"$RESPONSE\"}" >> "$HISTORY_FILE"
    else
        echo "Prompt not found."
    fi
}

function add_context_file() {
    echo "Enter path to file to add to context:"
    read -r FILE
    if [[ -f "$FILE" ]]; then
        cp "$FILE" "$CONTEXT_DIR/"
        echo "Added $FILE to context."
    else
        echo "File not found."
    fi
}

function menu() {
    echo "=== Ollama Assistant ==="
    echo "1) Ask a question"
    echo "2) View history"
    echo "3) Run a saved prompt"
    echo "4) Add file to context (RAG)"
    echo "5) Exit"
}

while true; do
    menu
    read -p "Choose: " CHOICE
    case "$CHOICE" in
        1) ask_question ;;
        2) view_history ;;
        3) load_prompt ;;
        4) add_context_file ;;
        5) echo "Goodbye!"; exit ;;
        *) echo "Invalid choice." ;;
    esac
done
