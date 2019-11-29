import express, {Request, Response} from "express";
import dotenv from "dotenv";
import PowerMarket from "./build/contracts/PowerMarket.json";

dotenv.config();

const app = express();
const port = process.env.API_PORT || 3000;

app.get("/abi", (req: Request, res: Response) => {
  res.json({abi: PowerMarket.abi});
});

app.get("/address", (req: Request, res: Response) => {
  res.json({address: process.env.CONTRACT_ADDRESS});
});

app.listen(port, () => {
  console.log(`listening on port ${port}...`);
});
