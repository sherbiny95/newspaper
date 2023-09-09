import React, { useState } from 'react';

const App = () => {
  const [data, setData] = useState([]);
  const [Title, setTitle] = useState('');
  const [date, setDate] = useState('');
  const [description, setDescription] = useState('');
  const [response, setResponse] = useState('');
  const [error, setError] = useState('');

  const handleGet = async () => {
    const response = await fetch('https://y15bdx7eij.execute-api.eu-west-1.amazonaws.com/dev/news', {
      method: 'GET'
    });

    if (response.ok) {
      const result = await response.json();
      setData(result || []);
    }
  };

  const handlePost = async () => {
    if (!Title || !date || !description) {
      setError('Please fill in all fields.');
      return;
    }
    const response = await fetch('https://y15bdx7eij.execute-api.eu-west-1.amazonaws.com/dev/newsitem', {
      method: 'POST',
    body: JSON.stringify({
      Title,
      date,
      description,
    }),
  });
    if (response.ok) {
      const result = await response.json();
      setResponse(result || []);
    }
  };

  return (
    <div>
      <h1>Newspaper</h1>

      <button onClick={handleGet}>Fetch News Items</button>

      {data.map((newsItem, index) => (
        <div key={index}>
          <h2>Title: {newsItem.Title}</h2>
          <p>Date: {newsItem.date}</p>
          <p>Description: {newsItem.description}</p>
          <hr />
        </div>
      ))}
      
      <h2>Post a News Item</h2>

      <input
        type="text"
        placeholder="Title"
        value={Title}
        onChange={(e) => setTitle(e.target.value)}
      />

      <input
        type="date"
        placeholder="Date"
        value={date}
        onChange={(e) => setDate(e.target.value)}
      />

      <input
        type="text"
        placeholder="Description"
        value={description}
        onChange={(e) => setDescription(e.target.value)}
      />

      <button onClick={handlePost}>Post News Item</button>

      {error && <p>{error}</p>}
      {response && <p>{response}</p>}

    </div>
  );
};

export default App;
