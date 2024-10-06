# cloud-project2-tf

AWS Lambda deployment of a simple flask webapp of a small Q&A model. Everything is deployed using Terraform.

![image](https://github.com/user-attachments/assets/af398b83-dd14-4282-8449-6717851eb1b5)

The model we used is a 24MB model called BERT-Tiny, fine-tuned for Q&A purpose.

The model is available from https://huggingface.co/mrm8488/bert-tiny-5-finetuned-squadv2. You will need to download the model there, and put it in the `model` folder of this repo before the image can be built properly.

You may visit the built webapp [here](https://d16y04fvgjdqwq.cloudfront.net/).
