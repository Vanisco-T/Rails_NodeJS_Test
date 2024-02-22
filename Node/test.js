import chai from 'chai';
import chaiHttp from 'chai-http';
import app from './index.js'; 

chai.use(chaiHttp);
const { expect } = chai;

describe('Content Moderation API', () => {
  it('should predict moderation correctly', async () => {
    const res = await chai
      .request(app)
      .post('/api/moderation/predict')
      .send({ text: 'Contenu à modérer', language: 'fr-FR' });
       expect(res).to.have.status(200);
       expect(res.body).to.have.property('prediction');
       expect(res.body.prediction[0]).to.be.a('number');
  });
});

