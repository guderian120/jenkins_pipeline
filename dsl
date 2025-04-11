job('SimpleWebApp-CICD') {
    description('CI/CD Pipeline for a Maven-based Java web app with deployment to Tomcat')

    label('linux_node') // Only run on the specified slave agent

    scm {
        git {
            remote {
                url('https://github.com/your-username/simpleWebApp.git')
            }
            branch('*/main') // Replace with your actual branch
        }
    }

    triggers {
        scm('H/1 * * * *') // Poll GitHub every minute
    }

    wrappers {
        preBuildCleanup() // Optional: cleans workspace before build
    }

    steps {
        maven {
            goals('clean package')
            mavenInstallation('Maven 3') // Make sure this name matches your Maven installation in Jenkins
        }
    }

    publishers {
        deployWar {
            war('**/target/*.war')
            contextPath('simpleWebApp')
            container('tomcat9') {
                url('http://your-tomcat-url:8080') // Replace with actual Tomcat server URL
                credentials('tomcat-creds-id') // Set this ID in Jenkins credentials
            }
        }
    }
}
