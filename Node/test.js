import chai from 'chai';
import chaiHttp from 'chai-http';
import app from './index.js'; 

chai.use(chaiHttp);
const { expect } = chai;

describe('Test de moderation', () => {
  it('moderation pour la prediction', async () => {
    const res = await chai
      .request(app)
      .post('/api/moderation/predict')
      .send({ text: 'les pirates le mal la marine la justice', language: 'fr-FR' });
       expect(res).to.have.status(200);
       expect(res.body).to.have.property('prediction');
       expect(res.body.prediction[0]).to.be.a('number');
  });
  it('moderation pour le score', async () => {
    const res = await chai
      .request(app)
      .post('/api/moderation/score')
      .send({ text: 'today we are going to talk about IT', language: 'en-EN' });
       expect(res).to.have.status(200);
       expect(res.body).to.have.property('score');
       expect(res.body.score).to.be.a('number');
  });
});

