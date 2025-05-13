#!/usr/bin/env python3.10

import sys
from pathlib import Path
from sentence_transformers import SentenceTransformer, util

model = SentenceTransformer('all-MiniLM-L6-v2')

question = sys.argv[1]
threshold = float(sys.argv[2]) if len(sys.argv) > 2 else 0.3  # Default threshold is 0.3

context_dir = Path("./context")
chunks = []

for file in context_dir.glob("*"):
    text = file.read_text()
    chunks.append((file.name, text))

# Embed the question and context texts
query_embedding = model.encode(question, convert_to_tensor=True)
texts = [text for _, text in chunks]
context_embeddings = model.encode(texts, convert_to_tensor=True)

# Compute cosine similarities
cos_scores = util.cos_sim(query_embedding, context_embeddings)[0]
ranked = sorted(zip(chunks, cos_scores), key=lambda x: x[1], reverse=True)

# Output top 2 most relevant chunks above the threshold
for (fname, text), score in ranked[:2]:
    if score >= threshold:
        print(f"### From {fname} ###\n{text.strip()}\n")
