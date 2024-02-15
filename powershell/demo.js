async function asyncCall() {
    const res = await fetch('http://127.0.0.1:8080/v2/apis/auth/oauth/token');
    const json = await res.json();
    console.log(json);
}
  
asyncCall();
  