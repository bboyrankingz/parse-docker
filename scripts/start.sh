config='{
  "apps": [
    {
      "serverURL": "http://adress:1337/parse",
      "appId": "id",
      "masterKey": "key",
      "appName": "MyApp"
    }
  ],
  "users": [
    {
      "user":"dashuser",
      "pass":"dashpass"
    }
  ]
}'

if [ -z $DOCKERCLOUD_NODE_FQDN ]
then
  IP=`dig +short myip.opendns.com @resolver1.opendns.com`
else
  ADRESS=$DOCKERCLOUD_NODE_FQDN
fi

config=${config/adress/$ADRESS$IP}
config=${config/id/$PARSE_SERVER_APPLICATION_ID}
config=${config/key/$PARSE_SERVER_MASTER_KEY}
config=${config/dashuser/$PARSE_DASH_USER}
config=${config/dashpass/$PARSE_DASH_PASS}

echo $config
echo $config > config.json

mongod --dbpath /db & 
parse-server & 
parse-dashboard --config config.json --port 4040 --allowInsecureHTTP=1
