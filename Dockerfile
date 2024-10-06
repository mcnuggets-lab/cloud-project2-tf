FROM public.ecr.aws/lambda/python:3.12

# Working directory
WORKDIR ${LAMBDA_TASK_ROOT}

# Copy source code to working directory
COPY src/app.py ${LAMBDA_TASK_ROOT}
COPY src/requirements.txt ${LAMBDA_TASK_ROOT}
COPY src/templates/ ${LAMBDA_TASK_ROOT}/templates/
COPY src/model/ ${LAMBDA_TASK_ROOT}/model/

# Install packages from requirements.txt
# torch must be installed here instead of from the requirements.txt to get the cpu version
# RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir -r requirements.txt --target "${LAMBDA_TASK_ROOT}"
RUN pip3 install --no-cache-dir torch==2.3.1 --index-url https://download.pytorch.org/whl/cpu --target "${LAMBDA_TASK_ROOT}"

EXPOSE 8080

CMD [ "app.handler" ]
