FROM node

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

EXPOSE 80

# # Anonymous volumn specifies a volumn path inside container
# VOLUME [ "/app/feedback" ]

CMD ["node", "server.js"]