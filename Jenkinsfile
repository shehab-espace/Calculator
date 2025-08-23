pipeline {
  agent {
    kubernetes {
      inheritFrom 'maven'          // your Pod Template (jnlp + kaniko)
      defaultContainer 'jnlp'
    }
  }

  // environment {
  //   REGISTRY   = "registry.jenkins.svc:5000"           
  //   IMAGE_NAME = "calculator"
  //   IMAGE_FULL = "${REGISTRY}/${IMAGE_NAME}"
  //   IMAGE_TAG  = "v${env.BUILD_NUMBER}"
  // }

  // stages {
  //   stage('Checkout') {
  //     steps { checkout(scm) }               // Dockerfile at repo root
  //   }

  //   stage('Build & Push (Kaniko ➜ local registry)') {
  //     steps {
  //       container('kaniko') {
  //         sh '''
  //           set -euxo pipefail
  //           /kaniko/executor \
  //             --context `pwd` \
  //             --dockerfile Dockerfile \
  //             --destination ${IMAGE_FULL}:${IMAGE_TAG} \
  //             --destination ${IMAGE_FULL}:latest \
  //             --insecure --skip-tls-verify
  //         '''
  //       }
  //     }
  //   }
  // }

  post {
    success {
  // echo "Image pushed: ${env.IMAGE_FULL}:${env.IMAGE_TAG} (and :latest)"
  // echo "Run on your desktop (X11):"
  echo "  xhost +local:docker"
  echo '  docker run -it --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:rw ${env.IMAGE_FULL}:latest'
    }
    failure { echo "Build failed; check stage logs." }
  }
}
