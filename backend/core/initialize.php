<?php
defined('DS') or define('DS', DIRECTORY_SEPARATOR);
defined('SITE_ROOT') or define('SITE_ROOT', __DIR__ . DS . '..' . DS);
defined('INC_PATH') or define('INC_PATH', SITE_ROOT . 'include' . DS);
defined('CORE_PATH') or define('CORE_PATH', SITE_ROOT . 'core' . DS);
require_once(CORE_PATH . 'administrateur.php');
require_once(CORE_PATH . 'fonctions.php');
require_once(CORE_PATH . 'commentaire.php');
require_once(CORE_PATH . 'ResponseCodes.php');
require_once(CORE_PATH . 'artiste.php');
require_once(CORE_PATH . 'espace.php');
require_once(CORE_PATH . 'evenement.php');
require_once(CORE_PATH . 'manageur.php');
require_once(CORE_PATH . 'organisateur.php');
require_once(CORE_PATH . 'register.php');
require_once(CORE_PATH . 'ticket.php');
require_once(CORE_PATH . 'visiteur.php');
require_once(CORE_PATH . 'countorga.php');
require_once(CORE_PATH . 'countespace.php');
require_once(CORE_PATH . 'countevent.php');
require_once(INC_PATH . 'config.php');

// require_once(INC_PATH . DS . 'config.php');

// require_once(CORE_PATH . DS . 'administrateur.php');
// require_once(CORE_PATH . DS . 'fonctions.php');

// require_once(CORE_PATH . DS . 'ResponseCodes.php');

// require_once(CORE_PATH . DS . 'artiste.php'); 

// require_once(CORE_PATH . DS . 'commentaire.php');

// require_once(CORE_PATH . DS . 'espace.php');

// require_once(CORE_PATH . DS . 'evenement.php');

// require_once(CORE_PATH . DS . 'evenements.php');

// require_once(CORE_PATH . DS . 'manageur.php');

// require_once(CORE_PATH . DS . 'organisateur.php');

// require_once(CORE_PATH . DS . 'register.php');

// require_once(CORE_PATH . DS . 'ticket.php');

// require_once(CORE_PATH . DS . 'visiteur.php');

// require_once(CORE_PATH . DS . 'ResponseCodes.php');

// ?>