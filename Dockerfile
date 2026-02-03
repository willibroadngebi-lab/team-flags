 HEAD
 Use Node.js 20 Alpine as base
FROM node:20-alpine
=======
# Team Flags EDU - Production-Grade Dockerfile
# Multi-stage build for optimal image size and security
# This Dockerfile demonstrates DevSecOps best practices
#
# Week 3: Docker Compose - This image works with docker-compose.yml
# Week 5+: Add Firebase credentials for authentication features
#
# Build: docker build -t team-flags-edu .
# Run:   docker run -p 3000:3000 -e MONGODB_URI=... team-flags-edu
 upstream/main

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy application files
COPY . .

<<<<<<< HEAD

# Copy service account and env file
COPY service-account.json ./
COPY .env.production ./
=======
# Set production environment
ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

# Build-time environment variables (dummy values for build only)
# Real values are passed at runtime via docker-compose.yml or -e flags
# MongoDB and Firebase are optional - app works without them for Week 2-4
ENV MONGODB_URI=""
ENV MONGODB_DB=team-flags-edu
ENV STUDENTS_COLLECTION=students
ENV SKIP_ENV_VALIDATION=true

# Build the Next.js application
# This creates an optimized production build
RUN npm run build

# ============================================
# Stage 3: Runner (Final Production Image)
# ============================================
FROM node:20-alpine AS runner
WORKDIR /app

# Install wget for health checks
RUN apk add --no-cache wget

# Security: Create a non-root user
# Running as root is a security risk
RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 nextjs
>>>>>>> upstream/main

# Set environment variables
ENV NODE_ENV=production
ENV GOOGLE_APPLICATION_CREDENTIALS=/app/service-account.json

# Build the application
RUN npm run build

# Expose port
EXPOSE 3000

<<<<<<< HEAD
# Start the application
CMD ["npm", "start"]
=======
# Set hostname to allow external connections
ENV HOSTNAME="0.0.0.0"
ENV PORT=3000

# Health check - Docker Compose uses this to verify the app is ready
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost:3000/api/health || exit 1

# Start the Next.js application
# Standalone mode uses server.js directly
CMD ["node", "server.js"]
>>>>>>> upstream/main
