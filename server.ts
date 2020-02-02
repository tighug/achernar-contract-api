import express, { Request, Response } from "express";
import dotenv from "dotenv";
import fs from "fs";
import UserMaster from "./build/contracts/UserMaster.json";
import ELECMaster from "./build/contracts/ELECMaster.json";
import MarketMaster from "./build/contracts/MarketMaster.json";

dotenv.config();

const app = express();

const CONTRACT_API_PORT = process.env.CONTRACT_API_PORT || 7000;
const addressData = JSON.parse(fs.readFileSync("./address.json", "utf-8"));

app.get("/", (req: Request, res: Response) => {
  res.json("Hello from contract-api");
});

app.get("/contract", (req: Request, res: Response) => {
  res.json({
    UserMaster: {
      abi: UserMaster.abi,
      address: addressData.UserMaster
    },

    ELECMaster: {
      abi: ELECMaster.abi,
      address: addressData.ELECMaster
    },

    MarketMaster: {
      abi: MarketMaster.abi,
      address: addressData.MarketMaster
    }
  });
});

app.listen(CONTRACT_API_PORT, () => {
  console.log(`listening on port ${CONTRACT_API_PORT}...`);
});
