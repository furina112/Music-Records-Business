<?php session_start(); require 'music_dbconfig.php';
if (isset($_SESSION['user_id'])) { header("Location: music_artist_index.php"); exit; }
$error = '';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $login = trim($_POST['username']);
    $s = $pdo->prepare("SELECT * FROM users WHERE username = ? OR email = ?");
    $s->execute([$login, $login]);
    $u = $s->fetch(PDO::FETCH_ASSOC);
    if ($u && password_verify($_POST['password'], $u['password'])) {
        session_regenerate_id(true);
        $_SESSION['user_id']   = $u['user_id'];
        $_SESSION['full_name'] = $u['first_name'] . ' ' . $u['last_name'];
        header("Location: music_artist_index.php"); exit;
    }
    $error = "Incorrect username/email or password!";
}
?>

<link href="https://fonts.googleapis.com/css2?family=Caveat:wght@500;700&family=Permanent+Marker&display=swap" rel="stylesheet">
   <?php include 'scrapbook.php'; ?>
<style>
  * { box-sizing: border-box; }

    body { margin: 0; min-height: 100vh; display: flex; justify-content: center; align-items: center; font-family: 'Caveat', cursive; }
  .wrap {
    position: relative;
    transform: rotate(-1.2deg);
    filter: drop-shadow(0 14px 22px rgba(0, 0, 0, 0.75));
  }


  .paper {
    position: relative;
    width: 440px;
    padding: 56px 46px 34px;
    text-align: center;
    color: #1b1b1b;
    background:
      url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='320' height='320'><filter id='n'><feTurbulence type='fractalNoise' baseFrequency='.85' numOctaves='3' stitchTiles='stitch'/><feColorMatrix values='0 0 0 0 0  0 0 0 0 0  0 0 0 0 0  0 0 0 .28 0'/></filter><rect width='100%' height='100%' filter='url(%23n)'/></svg>"),
      radial-gradient(circle at 20% 15%, rgba(255, 255, 255, .35), transparent 55%),
      radial-gradient(circle at 85% 90%, rgba(0, 0, 0, .18), transparent 50%),
      #d6d3cb;
    clip-path: polygon(2% 3%, 8% 0%, 15% 2%, 24% 0%, 33% 2%, 42% 0%, 52% 2%, 61% 0%, 70% 3%, 79% 1%, 88% 3%, 96% 0%,
                       100% 4%, 98% 14%, 100% 25%, 97% 36%, 100% 48%, 98% 60%, 100% 72%, 97% 84%, 100% 95%,
                       96% 100%, 88% 97%, 79% 100%, 69% 98%, 60% 100%, 50% 97%, 40% 100%, 30% 98%, 20% 100%, 11% 97%, 3% 100%,
                       0% 94%, 2% 83%, 0% 70%, 3% 58%, 0% 46%, 2% 34%, 0% 22%, 3% 11%);
  }


  .tape {
    position: absolute;
    top: -14px;
    left: 30px;
    width: 110px;
    height: 34px;
    z-index: 2;
    background: rgba(222, 200, 160, 0.82);
    transform: rotate(-6deg);
    clip-path: polygon(0 10%, 3% 0, 6% 12%, 9% 0, 100% 0, 97% 15%, 100% 30%, 97% 45%, 100% 60%, 97% 75%, 100% 90%, 100% 100%, 0 100%, 3% 85%, 0 70%, 3% 55%, 0 40%, 3% 25%);
  }

  h1 {
    margin: 0 0 8px;
    font-family: 'Permanent Marker', cursive;
    font-weight: 400;
    font-size: 46px;
    line-height: 1;
    letter-spacing: 1px;
    text-transform: uppercase;
    transform: rotate(-3deg);
  }

  .sub {
    display: inline-block;
    margin: 0 0 26px;
    padding-bottom: 2px;
    font-size: 24px;
    border-bottom: 2px solid #1b1b1b;
    transform: rotate(-2deg);
  }

  .msg { margin: 0 0 14px; font-size: 22px; font-weight: 700; }
  .ok  { color: #b0105a; }
  .err { color: #b3261e; }

  input {
    display: block;
    width: 100%;
    margin: 0 0 18px;
    padding: 14px 14px 14px 54px;
    font-family: 'Caveat', cursive;
    font-size: 24px;
    color: #1b1b1b;
    background-color: rgba(255, 255, 255, .28);
    background-repeat: no-repeat;
    background-position: 16px center;
    background-size: 24px;
    border: 1.5px solid #3a3a3a;
    border-radius: 4px;
    outline: none;
  }
  input::placeholder { color: #6d6a63; }
  input:focus { background-color: rgba(255, 255, 255, .55); border-color: #000; }

  input.user {
    background-image: url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%23222' stroke-width='1.8' stroke-linecap='round'><circle cx='12' cy='8' r='4'/><path d='M4 21c0-4.4 3.6-8 8-8s8 3.6 8 8'/></svg>");
  }
  input.pass {
    background-image: url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%23222' stroke-width='1.8' stroke-linecap='round'><rect x='5' y='11' width='14' height='10' rx='2'/><path d='M8 11V7a4 4 0 0 1 8 0v4'/></svg>");
  }

  /* black brush-stroke button */
  button {
    display: block;
    width: 74%;
    margin: 26px auto 18px;
    padding: 13px 0 11px;
    font-family: 'Permanent Marker', cursive;
    font-size: 28px;
    letter-spacing: 2px;
    text-transform: uppercase;
    color: #eee;
    background: #111;
    border: none;
    cursor: pointer;
    clip-path: polygon(2% 20%, 8% 4%, 20% 14%, 35% 2%, 50% 12%, 66% 0, 82% 10%, 96% 2%, 100% 28%, 97% 52%, 100% 78%, 95% 96%, 80% 88%, 62% 100%, 45% 90%, 28% 100%, 12% 90%, 3% 98%, 0 70%, 3% 45%);
    transition: transform .15s;
  }
  button:hover { transform: rotate(-1deg) scale(1.03); background: #000; }

  .reg { margin: 6px 0 0; font-size: 21px; }
  .reg a { color: #1b1b1b; font-weight: 700; }

  @media (max-width: 500px) {
    .paper { width: 92vw; padding: 48px 26px 28px; }
    h1 { font-size: 36px; }
  }
</style>

<div class="wrap">
  <span class="tape"></span>
  <div class="paper">
    <h1>Welcome Back</h1>
    <p class="sub">♫"Has it gone for good, or is it coming back around?"♫</p>

    <?php if (isset($_GET['registered'])) echo "<p class='msg ok'>Yippiee! You can log in now!</p>"; ?>
    <?php if (isset($_GET['loggedout']))  echo "<p class='msg ok'>Yeyyy! You are now logged out!</p>"; ?>
    <?php if ($error) echo "<p class='msg err'>" . htmlspecialchars($error) . "</p>"; ?>

    <form method="post">
      <input class="user" name="username" placeholder="Username" required>
      <input class="pass" name="password" type="password" placeholder="Password" required>
      <button>Login &rarr;</button>
    </form>

    <p class="reg">Awww, don't have an account yet? <a href="register.php">Register</a></p>
  </div>
</div>
