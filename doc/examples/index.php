<?php
  $message = array('method' => 'GET', 'date' => round(microtime(true) * 1000), 'data' => "/test" );

  echo json_encode($message, JSON_UNESCAPED_SLASHES);
  $hash = hash_hmac('sha256', json_encode($message, JSON_UNESCAPED_SLASHES), 'test_secret', false);
  $signature = 'test_signature';

  $curl = curl_init();

  curl_setopt_array($curl, array(
    CURLOPT_RETURNTRANSFER => 1,
    CURLOPT_URL            => 'http://localhost:9292/test',
    CURLOPT_USERAGENT      => 'Sample cURL Request'
  ));

  curl_setopt($curl, CURLOPT_HTTPHEADER, array("AUTHORIZATION: $hash:$signature"));

  $resp = curl_exec($curl);

  curl_close($curl);
?>
<html>
  <head>
    <title>HMAC Test</title>
  <head>
  <body>
    <div class="wrapper">
      <p>Sending request with AUTHORIZATION Header: <?php echo $hash.":".$signature; ?></p>
      <p>PHP Request (via cURL) - Response: <?php echo $resp; ?> </p>
    </div>
  </body>
</html>
