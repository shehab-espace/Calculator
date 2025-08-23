pipeline {
  agent {
    kubernetes {
      inheritFrom 'maven'          // your Pod Template (jnlp + kaniko)
      defaultContainer 'jnlp'
    }
  }
  options { timestamps() }

  environment {
    // In-cluster registry Service (adjust if your Service is named differently)
    REGISTRY   = "registry:5000"           // or "registry.jenkins.svc:5000"
    IMAGE_NAME = "calculator"              // change if you want another repo name
    IMAGE_FULL = "${REGISTRY}/${IMAGE_NAME}"
    IMAGE_TAG  = "v${env.BUILD_NUMBER}"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout(scm)                       // expects Dockerfile at repo root
      }
    }

    stage('Unit Tests') {
      steps {
        container('jnlp') {
          sh 'mvn -B test'
        }
      }
    }

    stage('Build & Push (Kaniko ➜ local registry)') {
      steps {
        container('kaniko') {
          sh '''
            set -euxo pipefail
            # Build and push to the in-cluster HTTP registry
            /kaniko/executor \
              --context `pwd` \
              --dockerfile Dockerfile \
              --destination ${IMAGE_FULL}:${IMAGE_TAG} \
              --destination ${IMAGE_FULL}:latest \
              --insecure --skip-tls-verify
          '''
        }
      }
    }
  }

  post {
    success {
      echo "Image pushed: ${env.IMAGE_FULL}:${env.IMAGE_TAG} (and :latest)"
      echo "Run it on your desktop (X11) if you want:"
      echo "  xhost +local:docker"
      echo "  docker run -it --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:rw ${env.IMAGE_FULL}:latest"
    }
    failure {
      echo "Build failed; check stage logs."
    }
  }
}
