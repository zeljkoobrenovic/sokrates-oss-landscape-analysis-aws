import { ECSClient, RunTaskCommand } from "@aws-sdk/client-ecs";

const ecsClient = new ECSClient();

export const handler = async (event) => {
  const payload = event.payload;

  const params = {
    cluster: 'your-cluster-name',
    taskDefinition: 'your-task-definition',
    launchType: 'FARGATE',
    count: 1,
    networkConfiguration: {
      awsvpcConfiguration: {
        subnets: ['subnet-xxxxxx', 'subnet-yyyyyy'],
        securityGroups: ['sg-xxxxxx'],
        assignPublicIp: 'ENABLED' // or 'DISABLED' depending on your network setup
      }
    },
    overrides: {
      containerOverrides: [
        {
          name: 'your-container-name',
          environment: Object.entries(payload).map(([name, value]) => ({
            name,
            value: String(value)
          }))
        }
      ]
    }
  };

  try {
    const command = new RunTaskCommand(params);
    const result = await ecsClient.send(command);
    return {
      taskArn: result.tasks[0].taskArn,
      payload
    };
  } catch (error) {
    console.error('Error starting task:', error);
    throw error;
  }
};