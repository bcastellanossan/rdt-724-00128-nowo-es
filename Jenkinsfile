//Library to use
@Library('hocelot-shared-library')

def config = readYaml text: """                       
---
  APP_TYPE: 'rdtMultibranchFast'
  skipTest: 'true'
  clust_default: 'k8s-eu-dev'
"""

//Create an environment map
config.keySet().each{                       
    env."${it}" = config[it]                  
}       

//Calling pipeline selector                                      
def pipelineToRun = pipelineSelection(env)       
                                       
echo """                       
Pipeline Running: ${pipelineToRun}                      
"""       

//Execute                
"${pipelineToRun}"()
