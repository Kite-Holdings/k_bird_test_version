var htmlTemplate  = '''
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
body {font-family: Arial, Helvetica, sans-serif;}

/* The Modal (background) */
.modal {
  display: bolck; /* Hidden by default */
  position: fixed; /* Stay in place */
  z-index: 1; /* Sit on top */
  padding-top: 250px; /* Location of the box */
  left: 0;
  top: 0;
  width: 100%; /* Full width */
  height: 100%; /* Full height */
  overflow: auto; /* Enable scroll if needed */
  background-color: rgb(0,0,0); /* Fallback color */
  background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
}

/* Modal Content */
.modal-content {
  position: relative;
  background-color: #fefefe;
  margin: auto;
  padding: 0;
  border: 1px solid #888;
  width: 40%;
  box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2),0 6px 20px 0 rgba(0,0,0,0.19);
}

.modal-header {
  padding: 2px 16px;
  background-color: #5cb85c;
  color: white;
}

.modal-body {padding: 2px 16px;}



.loader {
  position: relative;
  margin: 0px auto;
  width: 100px;
  height:100px;
}
.circular{animation:rotate 2s linear forwards ;width:100px;height:100px;position:relative}
.path{stroke:#007aff; stroke-dasharray: 1,200;
  stroke-dashoffset: 0;
  animation: 
   dash 1.5s ease-in-out forwards,
   color 6s ease-in-out infinite
  ;
  stroke-linecap: round;}
  @keyframes dash{
 0%{
  stroke-dasharray: 1,200;
  stroke-dashoffset: 0;
 }

 100%{
  stroke-dasharray: 150,200;
  stroke-dashoffset: 10;
 }

}
@keyframes color{
  100%, 0%{
    stroke: #f00;
  }
  40%{
    stroke: #007aff;
  }
  66%{
    stroke: #24555d;
  }
  80%, 90%{
    stroke: #789642;
  }
}
@keyframes rotate{
	100%{transform:rotate(360deg)}
	}
	
.checkmark__check {
    transform-origin: 50% 50%;
    stroke-dasharray: 48;
    stroke-dashoffset: 48;
	
	 animation: stroke 0.5s  cubic-bezier(0.65, 0, 0.45, 1) 1.5s forwards, color 6s linear infinite;}
	@keyframes stroke {
  100% {
    stroke-dashoffset: 0;
  }
}
.suc{stroke:#007aff;
	stroke-width:5;
	position:absolute;top:30px;left:30px;
	width:40px;height:40px;}


</style>
</head>
<body>

<!-- The Modal -->
<div id="myModal" class="modal">

  <!-- Modal content -->
  <div class="modal-content">
    <div class="modal-header">
      <h2>Transaction Successful</h2>
    </div>
    <div class="modal-body">
      
      <div class="loader">
        <svg class="circular">
           <circle class="path" cx="50" cy="50" r="40" fill="none" stroke-width="4"  stroke-color="#f00" stroke-miterlimit="10"/>

        </svg>
        <svg class="suc">
        <path class="checkmark__check" fill="none" d="M10.7,20.4l5.3,5.3l12.4-12.5"></path>
        </svg>
      </div>
      
      
    </div>
  </div>

</div>

</body>
</html>
''';