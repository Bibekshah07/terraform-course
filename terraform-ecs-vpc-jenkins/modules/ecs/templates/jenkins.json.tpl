[
  {
    "name": "${name}",
    "image": "${image}",
    "cpu": 128,
    "memory": 1024,
    "essential": true,
    "portMappings": [
      {
        "containerPort": ${port},
        "hostPort": ${port}
      },
      {
        "containerPort": ${agent},
        "hostPort": ${agent}
      }
    ],
    "mountPoints": [
      {
        "sourceVolume": "jenkins-home",
        "containerPath": "/var/jenkins_home"
      }
    ]
  }
]
