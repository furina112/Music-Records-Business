<?php
require 'authentication.php';
require 'music_dbconfig.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['restore_id'])) {
    $pdo->prepare("UPDATE records SET deleted_at = NULL, deleted_by = NULL WHERE record_id = ?")
        ->execute([$_POST['restore_id']]);
    header("Location: records_index.php?artist_id=" . (int)$_POST['artist_id']);
    exit;
}

$sql = "SELECT r.*, a.artist_name,
               CONCAT(u.first_name,' ',u.last_name) AS deleted_by_name
        FROM records r
        JOIN artists a ON r.artist_id = a.artist_id
        LEFT JOIN users u ON r.deleted_by = u.user_id
        WHERE r.deleted_at IS NOT NULL
        ORDER BY r.deleted_at DESC";
$records = $pdo->query($sql)->fetchAll(PDO::FETCH_ASSOC);
?>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Recycle Bin</title>
  <style>
    body { font-family: sans-serif; padding: 40px; background: #1a1a1a; color: #eee; }
    table { width: 100%; border-collapse: collapse; }
    th, td { padding: 10px; text-align: left; border-bottom: 1px solid #444; }
    th { text-transform: uppercase; font-size: 13px; }
    a.back { color: #ccc; }
    button.restore { background: #4caf50; color: #fff; border: 0; padding: 6px 12px; cursor: pointer; }
  </style>
</head>
<body>
  <p><a class="back" href="music_artist_index.php">&larr; Back to the Artist Wall</a></p>
  <h1>🗑 Recycle Bin</h1>
  <table>
    <tr><th>ID</th><th>Artist</th><th>Title</th><th>Deleted By</th><th>Deleted At</th><th>Action</th></tr>
    <?php foreach ($records as $r): ?>
    <tr>
      <td><?= htmlspecialchars($r['record_id']) ?></td>
      <td><?= htmlspecialchars($r['artist_name']) ?></td>
      <td><?= htmlspecialchars($r['title']) ?></td>
      <td><?= htmlspecialchars($r['deleted_by_name'] ?? '—') ?></td>
      <td><?= htmlspecialchars($r['deleted_at']) ?></td>
      <td>
        <form method="post" style="display:inline">
          <input type="hidden" name="restore_id" value="<?= (int)$r['record_id'] ?>">
          <input type="hidden" name="artist_id" value="<?= (int)$r['artist_id'] ?>">
          <button type="submit" class="restore">Restore</button>
        </form>
      </td>
    </tr>
    <?php endforeach; ?>
    <?php if (!$records): ?>
      <tr><td colspan="6">The recycle bin is empty.</td></tr>
    <?php endif; ?>
  </table>
</body>
</html>
