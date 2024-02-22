import express from 'express';
import bodyParser from 'body-parser';
import axios from 'axios';

const app = express();
const port = 3000;

app.use(bodyParser.json());


//pour obtenir une predition sur la moderation
app.post('/api/moderation/predict', async (req, res) => {
  const { text, language } = req.body;
  try {
    //utilisation de l'api de Logora pour la predition
    const response = await axios.get('https://moderation.logora.fr/predict', {
        params: {
            text,
            language,
          },
    });
    //console.log(response.data.prediction)
    const prediction = response.data.prediction;
    res.json({ prediction });
  } catch (error) {
   // console.error(error);
    res.status(500).json({ error: 'erreur du serveur' });
  }
});

// pour obtenir un score de qualite
app.post('/api/moderation/score', async (req, res) => {
  const { text, language } = req.body;

  try {
   //utilisation de l'api de Logora pour le score
    const response = await axios.get('https://moderation.logora.fr/score', {
        params: {
            text,
            language,
          },
    });
    const score = response.data.score;
    res.json({ score });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

//demarrer le serveur
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
export default app