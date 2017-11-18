node {

    stage 'Checkout'
            checkout([$class: 'GitSCM', branches: [[name: '*/master']], userRemoteConfigs: [[url: 'https://github.com/gorbyo/nginx-lua.git']]])


    stage 'Build'
        def app = docker.build "gorbyo/nginx-lua:${env.BUILD_NUMBER}"


    stage 'Publish'
        docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
            app.push("latest")
        }

    stage 'Deploy'
      sh '/usr/local/bin/docker-machine ssh docker-sandbox docker stop webserver'
      sh '/usr/local/bin/docker-machine ssh docker-sandbox docker rm webserver'
      sh '/usr/local/bin/docker-machine ssh docker-sandbox docker pull gorbyo/nginx-lua'
      sh '/usr/local/bin/docker-machine ssh docker-sandbox docker run -d -p 80:80 --name webserver gorbyo/nginx-lua'

}
