const express = require("express");
const app = express();

app.get("/", (req, res) => {
    res.send("Hello from BTP! If you can see this, the deploy worked.");
});

const port = process.env.PORT || 3000;
app.listen(port, () => {
    console.log(`Hello world app listening on port ${port}`);
});