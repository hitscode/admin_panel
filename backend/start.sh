echo "#!/bin/bash
gunicorn -w 4 -k uvicorn.workers.UvicornWorker main:app" > start.sh
chmod +x start.sh
