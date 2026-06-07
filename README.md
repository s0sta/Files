# Files



curl -sSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc \
  | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null \
  && echo "deb https://ngrok-agent.s3.amazonaws.com bookworm main" \
  | sudo tee /etc/apt/sources.list.d/ngrok.list \
  && sudo apt update \
  && sudo apt install ngrok


  ngrok config add-authtoken $2uPb9JC9qqLmyrWKpMM9loXlEyR_3fUtXn5u7c85utM2ftghE


  ngrok http 80
