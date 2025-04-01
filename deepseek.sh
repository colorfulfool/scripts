ollama run deepseek-r1:14b
docker run -d -p 2200:8080 --add-host=host.docker.internal:host-gateway -v open-webui-new:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main
