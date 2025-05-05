use powertop to meauser consuption on intel devices



rpi consuption measuer 
```bash
vcgencmd measure_volts   
vcgencmd measure_clock arm   
vcgencmd measure_temp   
```


download link 

https://ollama.com/download


```bash
curl -fsSL https://ollama.com/install.sh | sh
```

to run 
```bash
ollama run codellama:7b to 
```
run this model

You can 

```bash
ollama list
```
to see models or to delete with 

```bash
ollama rm llama2:7b
```

You can install with 
```bash
ollama pull tinyllama
```

