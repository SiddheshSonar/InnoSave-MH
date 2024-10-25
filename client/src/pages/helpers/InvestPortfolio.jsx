import React from "react";
import ChatPage from "./ChatPage";
import { Typography, Container } from "@mui/material";

function App() {
  return (
    <Container className="flex flex-col items-center justify-center h-screen bg-gray-100">
      <Typography variant="h4" component="h1" className="mb-6 text-blue-700">
        Financial Chat Assistant
      </Typography>
      <ChatPage endpoint="/portfolio" title="Investment Chat" />
    </Container>
  );
}

export default App;
