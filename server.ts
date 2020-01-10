import express, { Request, Response } from "express";
import dotenv from "dotenv";
import fs from "fs";
import PowerMarket from "./build/contracts/ElectricityMarket.json";

dotenv.config();

const app = express();
const PORT = process.env.CONTRACT_API_PORT || 7000;
const ADDRESS = fs.readFileSync("market", "utf-8");

app.get("/contract", (req: Request, res: Response) => {
  res.json({
    abi: PowerMarket.abi,
    address: ADDRESS
  });
});

app.listen(PORT, () => {
  console.log(`listening on port ${PORT}...`);
});
