Terminalde  mevcut yüklü modelleri gör 

```bash
ollama list
```

 To install jq (the lightweight JSON processor) on your Linux system, just run the command appropriate to your distribution:
 
```bash
sudo apt update
sudo apt install jq
```

.
├── context/        # for context files to use in RAG
├── prompts/        # for reusable prompt templates
├── ollama_history.jsonl
└── ollama-assistant.sh



```bash
chmod +x ollama-assistant.sh  # Make it executable (only once)
./ollama-assistant.sh         # Run the script
```

to get context based we use sentence transformer

```bash
chmod +x context_retriever.py
```

```bash
python3.10 -m pip install sentence-transformers
```
test context retriever 

```bash
python3.10 context_retriever.py "Your question here" 0.3
```
