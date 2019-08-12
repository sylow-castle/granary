const config = require("./watasi.conf.json");
const ips = [process.argv[2], process.argv[3]]
var next_ip;

if(next_ip = needChangeRecords(ips)) {
  console.log("start DNS recrod update... ");
  updateDNSRecord(config.id, config.key, next_ip);
}
/**
 * 渡したIPアドレスのリストから更新が必要かどうかを判定する
 * 最新のIPを返却する
 * 
 * @param {string[]} ips indexは0から始まる。0が一番古いIP
 * @return {string} 変更後のIP。変更しないときはnull
 */
function needChangeRecords(ips) {
  if(!ips && ips.length === 0 ){ 
    return null;
  }
  console.log(ips);

  var current = ips[0];
  var changeCount = 0;

  for(var index = 0; index < ips.length; index++) {
    console.log(ips[index]);
     if(ips[index] !==  current) {
        current = ips[index];
        changeCount++;
     }
  }

  //IPの変化が多すぎるときは変なところからアクセスされてると想定
  //ログファイルが変わって十分なデータが集まる前はfalseに。
  const result = changeCount === 1 ?  current : null;
  return result;
}

/**
 * DNSレコードを変更する。
 * 
 * @param {string} access 
 * @param {string} secret 
 * @param {string} ip 変更後のIP
 */
function updateDNSRecord(access, secret, ip) {
  var AWS = require('aws-sdk');

  var keys = {
    accessKeyId: access,
    secretAccessKey: secret
  };


  var route53 = new AWS.Route53(keys);
  var params = config.params;
          params.ChangeBatch.Changes[0].ResourceRecordSet.ResourceRecords[0].Value = ip;

  route53.changeResourceRecordSets(params, function (err, data) {
    if (err) console.log(err, err.stack); // an error occurred]
    else console.log(data);
  });
}