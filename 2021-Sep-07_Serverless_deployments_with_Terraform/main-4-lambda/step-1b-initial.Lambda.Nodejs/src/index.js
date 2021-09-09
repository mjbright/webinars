
// Handler
exports.lambda_handler =  async function(event, context) {
  console.log('');
  console.log('---- env variables ------');
  console.log( JSON.stringify(process.env, null, 2) )

  console.log('');
  console.log('---- events info --------');
  console.log( JSON.stringify(event, null, 2) )

  console.log('');
  console.log('---- runtime ------------');
  console.log(`[Node ${process.version}]: Entering into lambda_handler`);

  //return "Returning from lambda_handler"
  console.log('');
  return context.logStreamName
}

exports.lambda_handler2 = async function(event, context) {
  console.log('');
  console.log('---- env variables ------');
  console.log( JSON.stringify(process.env, null, 2) )

  console.log('');
  console.log('---- events info --------');
  console.log( JSON.stringify(event, null, 2) )

  console.log('');
  console.log('---- runtime ------------');
  console.log(`[Node ${process.version}]: Entering into lambda_handler2`);

  //return "Returning from lambda_handler2"
  console.log('');
  return context.logStreamName
}

