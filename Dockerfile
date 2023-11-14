# Stage 1
FROM node:18 as build-stage
# set working directory
RUN mkdir /usr/app
#copy all files from current directory to docker
COPY . /usr/app
ENV REACT_APP_HOST=backend
ENV REACT_APP_HOST_PYTHON=ai-core
ENV REACT_APP_HOST_AUTH=authentication
ENV REACT_APP_HOST_MLFLOW=mlflow
ENV REACT_APP_HOST_SIGNOZ=signoz
ENV PORT=3005
EXPOSE 3005
WORKDIR /usr/app
# install and cache app dependencies
RUN npm install
RUN npm run build
# Stage 2
# Copy the react app build above in nginx
FROM nginx
# Copy static assets from builder stage
COPY --from=build-stage /usr/app/build /usr/share/nginx/html
COPY default.conf /etc/nginx/conf.d/default.conf
# Containers run nginx with global directives and daemon off
ENTRYPOINT ["nginx", "-g", "daemon off;"]
