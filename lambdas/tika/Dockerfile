FROM public.ecr.aws/lambda/nodejs:14

ARG YARN_ARGS="--production --frozen-lockfile"

# Copy function code
COPY lib ${LAMBDA_TASK_ROOT}/lib
COPY index.js ${LAMBDA_TASK_ROOT}
COPY package.json yarn.lock ${LAMBDA_TASK_ROOT}/

WORKDIR ${LAMBDA_TASK_ROOT}

RUN npm install -g yarn 

RUN yarn install ${YARN_ARGS}
# Set the CMD to your handler (could also be done as a parameter override outside of the Dockerfile)
CMD [ "index.handler" ]