<?php
if (isset($_GET['code'])) {
	header('Location: BPSensit://code='.$_GET['code']);
}
exit;
?>