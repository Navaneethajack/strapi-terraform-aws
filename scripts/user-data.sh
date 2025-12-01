#!/bin/bash

# Update system
apt-get update
apt-get upgrade -y

# Install Node.js (LTS version)
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
apt-get install -y nodejs

# Install Python and build tools
apt-get install -y python3 python3-pip build-essential

# Install PM2 process manager
npm install -g pm2

# Create Strapi application directory
mkdir -p /opt/strapi
cd /opt/strapi

# Create a new Strapi project
npx create-strapi-app@latest my-project --quickstart --no-run

cd my-project

# Create environment configuration
cat > config/server.js << EOF
module.exports = ({ env }) => ({
  host: env('HOST', '0.0.0.0'),
  port: env.int('PORT', 1337),
  app: {
    keys: env.array('APP_KEYS', ['defaultKey1', 'defaultKey2']),
  },
});
EOF

# Create environment file
cat > .env << EOF
HOST=0.0.0.0
PORT=1337
NODE_ENV=production
EOF

# Build Strapi for production
NODE_ENV=production npm run build

# Create PM2 ecosystem file
cat > ecosystem.config.js << EOF
module.exports = {
  apps: [
    {
      name: 'strapi',
      cwd: '/opt/strapi/my-project',
      script: 'npm',
      args: 'start',
      env: {
        NODE_ENV: 'production',
        HOST: '0.0.0.0',
        PORT: '1337',
      },
    },
  ],
};
EOF

# Start Strapi with PM2
pm2 start ecosystem.config.js
pm2 startup
pm2 save
