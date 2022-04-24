const AWS = require('aws-sdk');
const batch = new AWS.Batch({ apiVersion: '2016-08-10', region: process.env.AWS_DEFAULT_REGION });

const params = {
  jobName: 'test_job_001',
  jobDefinition: 'batch-compute-development-job-definition',
  jobQueue: 'batch-compute-development-job-queue',
  containerOverrides: {
    command: ["ls", "-lth", "/tmp"],
    environment: [
      {
        name: 'VARIABLE_NAME',
        value: 'VARIABLE_VALUE'
      },
    ],
    memory: '1024',
    vcpus: '1',
  },
  timeout: {
    attemptDurationSeconds: '300'
  },
  propagateTags: true,
};

batch.submitJob(params, function(err, data) {
  if (err) {
    console.log(err, err.stack);
    return;
  }
  console.log(data);
});

// const params = {
//   jobId: '',
//   reason: 'Cancelling job'
// };

// batch.cancelJob(params, function(err, data) {
//   if (err) {
//     console.log(err, err.stack);
//     return;
//   }
//   console.log(data);
// });
