#Below dockerfile is for running in prod
FROM node:alpine as builder
WORKDIR '/app'
COPY package.json .
RUN npm install
#Here , we are not adding the volumes because, live updates is not allowed in prod. 
COPY . .
#Below will create the directory /app/build and copy all the files here. Even the files related to the above images, layers etc will all be part of this 
#build directory. Hence, we just will need BUILD directory for this application to execute in prod.
RUN npm run build


#Below is new block started which is independent of the above block. But we are just copying the build generated from above block to folder in nginx
#so that the nginx server can serve it. After we copy the build, its dumping automatically everything else which was generated.
#More info is present at https://docs.docker.com/develop/develop-images/multistage-build/
FROM nginx
COPY --from=builder /app/build /usr/share/nginx/html
