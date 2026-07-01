# HelperModel-NLP-26S-stat-NKU
Dynamic Memory Management System for Long Conversations Based on Auxiliary Models 

## Project Overview

In scenarios such as long conversations and role-playing, the continuous accumulation of dialogue context can cause a surge in Token overhead and a decline in the large model's reasoning performance. To address this, we introduce a system utilizing a lightweight auxiliary model for incremental outline extraction and dynamic updating. By condensing and compressing key historical information, it provides a streamlined memory for the main model, effectively reducing Token consumption in multi-turn dialogues and mitigating model degradation.

## 1. Repository Structure

```text
.
├── notebooks/
│   ├── 01_data.ipynb       # Script data batch generation, incremental outline annotation, and automated quality inspection/cleaning
│   ├── 02_training.ipynb   # Base model 4-bit quantization stress testing and two-stage mixed-precision fine-tuning
│   ├── 03_excution.ipynb   # Fine-tuned model deployment and A/B dual-track end-to-end evaluation execution
│   └── 04_test.ipynb       # Physical performance metrics statistics, ablation study blind test scoring, and visualization
├── LICENSE                 # Project Apache 2.0 License file
├── README.md               # Project documentation
└── setup_env.sh            # One-click environment configuration script for core dependencies (Unsloth, ModelScope, etc.)

```

## 2. Environment & Core Components

* **Base Model:** Qwen3.5-9B
* **Hardware:** 32G vGPU
* **Dual-Model Architecture:**
* **Local Auxiliary Model:** Qwen3.5-Helper, utilizing local GPU computing power to focus on incremental compression and state extraction of long contexts.


* **Main Model:** DeepSeek API (Cloud), dedicated to high-quality immersive role-playing and plot advancement.





## 3. Data & Methodology

### 3.1 Data Generation and Preprocessing

**Generation:** A corpus of 100 long conversation scripts spanning 8 categories (e.g., Xianxia, History, Cyberpunk) was automatically generated using DeepSeek-V3. The structural creation process involves planning a 5-act outline first, then forcing 40+ dialogue turns per act to ensure information density.


**Slicing:** Long conversations are segmented into chunks of 30 turns.


**Output:** The final processed data is a structured JSON format containing summaries, role states, and key events, which integrates new information and simplifies redundant old information.


**Cleaning:** Automated formatting validation removes unparseable JSON data, and field completion checks ensure every entry contains core memory fields. 100 entries are reserved as the test set.



### 3.2 Two-Phase Training Strategy

To prevent Mode Collapse and loss of semantic understanding from repetitive JSON training, 10% normal domain summaries (e.g., science, history) were injected as an implicit regularization term during training.

**Preprocessing Mechanisms:** * **Token Label Masking:** The Token length of the Prompt is calculated and replaced with `-100` in the labels. This allows the model to only compute Loss for the Assistant's output, preventing the memorization of prompts and boosting efficiency.


**Reasoning Block:** `{"enable_thinking": false}` is forced into the system instructions to prevent excessive model reasoning.




**Phase 1: Coarse Tuning:** Utilizes a 4-bit QLoRA architecture with an 8K window and regularized data. This allows the model to establish long-distance dependencies and adapt quickly without overfitting to specific formats.


**Phase 2: Fine Tuning:** Switches back to the LoRA architecture with the base model loaded in lossless bfloat16 full precision. The context window is reduced to 4K, and training runs for 1 Epoch on purely JSON data to strictly solidify the output format.



### 3.3 Dynamic Integration

The system features a sliding window scheduler that monitors dialogue accumulation. Once a set threshold is reached, it triggers the local auxiliary model to intercept old conversations. The updated global JSON outline is then automatically concatenated with recent short-term texts and sent to the main model.

## 4. Evaluation & Results

The system's performance was evaluated against a non-finetuned Base model and an uncompressed baseline:

**Token Consumption:** In an extreme long-dialogue test (2260 turns), the finetuning mechanism compressed total Token usage from nearly 130 million to roughly 21 million, achieving an 83.67% reduction.


**Summarization Quality (ROUGE-L):** The deep fine-tuned (FT) model achieved a ROUGE-L score of 30.20%, compared to the base model's 0.97%, placing it within an excellent benchmark range for Chinese long-text generative summarization tasks.


**Core Plot Recall:** The FT model captured 84.00% of crucial plot points and foreshadowing, vastly outperforming the base model's 12.00%.


**Logical Consistency:** In human/LLM blind testing, the FT auxiliary model consistently maintained perfect script logic in extreme late-stage scenarios (scoring 5/5), whereas the un-finetuned baseline frequently caused format breakdown and logical confusion.



## 5. Licenses

* **Data Authorization:** CC BY-NC 4.0
* **Project Code:** Apache 2.0
