<?php
require 'authentication.php';
require 'music_dbconfig.php';

$pdo->prepare("UPDATE records SET deleted_at = NOW(), deleted_by = ? WHERE record_id = ?")
    ->execute([$uid, $_GET['id']]);

header("Location: records_index.php?artist_id=" . $_GET['artist_id']);
exit;
