echo "Deploying to staging server..."

# Define variables
APP_NAME="6.2CJenkins-1.0-SNAPSHOT.jar"
STAGING_DIR="/var/www/staging"
USER="your-ssh-user"
HOST="your-staging-server"

# Copy the JAR file to the staging server (modify SCP path)
scp target/$APP_NAME $USER@$HOST:$STAGING_DIR/

# SSH into the server and restart the application (modify as needed)
ssh $USER@$HOST << EOF
    cd $STAGING_DIR
    pkill -f $APP_NAME || true  # Kill old process if running
    nohup java -jar $APP_NAME > output.log 2>&1 &
EOF

echo "Deployment to staging completed!"
