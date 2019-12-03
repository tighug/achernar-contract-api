import express, {Request, Response} from "express";
import dotenv from "dotenv";
import fs from "fs";
import PowerMarket from "./build/contracts/PowerMarket.json";

dotenv.config();

const app = express();
const port = process.env.CONTRACT_API_PORT || process.env.PORT || 7000;
const address = fs.readFileSync("power-market", "utf-8");

app.get("/contract", (req: Request, res: Response) => {
  res.json({
    abi: PowerMarket.abi,
    address: address
  });
});

app.listen(port, () => {
  console.log(`listening on port ${port}...`);
});
