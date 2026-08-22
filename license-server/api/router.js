import crypto from 'node:crypto';

const OWNER = process.env.GITHUB_OWNER || 'melissakant7-hash';
const REPO = process.env.GITHUB_REPO || 'ai-empire-tycoon-updates';
const BRANCH = process.env.GITHUB_BRANCH || 'main';
const BUNDLE_URL = `https://raw.githubusercontent.com/${OWNER}/${REPO}/${BRANCH}/license/revocations.bundle.json`;
const DOMAIN = Buffer.from('AI Training Revocation List v1\0', 'utf8');
const PUBKEY_B64 = 'yUzK0Zc4J1Fz+5Orr3opEiBe1G85gzCYOfUhsrPYoPk=';

function send(res,status,body){res.statusCode=status;res.setHeader('Content-Type','application/json; charset=utf-8');res.setHeader('Cache-Control','no-store, no-cache, must-revalidate, max-age=0');res.setHeader('Pragma','no-cache');res.end(JSON.stringify(body));}
function normId(v){return String(v||'').trim().toLowerCase();}
function normHw(v){return String(v||'').trim().toUpperCase();}
function b64d(s){s=String(s||'').replace(/-/g,'+').replace(/_/g,'/');while(s.length%4)s+='=';return Buffer.from(s,'base64');}
function pubKey(raw){const prefix=Buffer.from('302a300506032b6570032100','hex');return crypto.createPublicKey({key:Buffer.concat([prefix,raw]),format:'der',type:'spki'});}
async function state(){const r=await fetch(`${BUNDLE_URL}?t=${Date.now()}`,{cache:'no-store',headers:{'User-Agent':'AI-Training-License-Server/2'}});if(!r.ok)throw new Error(`revocation bundle HTTP ${r.status}`);const bundle=await r.json();const payload=b64d(bundle.payload);const sig=b64d(bundle.signature);const raw=Buffer.from(PUBKEY_B64,'base64');if(!crypto.verify(null,Buffer.concat([DOMAIN,payload]),pubKey(raw),sig))throw new Error('invalid revocation signature');return JSON.parse(payload.toString('utf8'));}
function decision(s,licenseId,hardwareId){const lid=normId(licenseId),hw=normHw(hardwareId);for(const e of s.revoked||[]){if(lid&&normId(e.id||e.license||e.licenseId)===lid)return{blocked:true,reason:e.reason||'License revoked'};}for(const e of s.blockedHardware||[]){if(hw&&normHw(e.hardwareId)===hw)return{blocked:true,reason:e.reason||'Hardware blocked'};}return{blocked:false,reason:''};}
async function body(req){const chunks=[];for await(const c of req)chunks.push(c);const raw=Buffer.concat(chunks).toString('utf8');return raw?JSON.parse(raw):{};}

export default async function handler(req,res){try{if(req.method==='OPTIONS'){res.statusCode=204;res.end();return;}const u=new URL(req.url,'http://localhost');const path=u.pathname.replace(/^\/api\/router\.js/,'').replace(/^\/v1/,'')||'/';if(req.method==='GET'&&(path==='/'||path==='/health'))return send(res,200,{ok:true,service:'ai-training-license-session',mode:'stateless-403',now:new Date().toISOString()});if(req.method==='POST'&&(path==='/session/start'||path==='/session/check'||path==='/session/renew')){const b=await body(req),licenseId=normId(b.licenseId),hardwareId=normHw(b.hardwareId);if(!licenseId||!hardwareId)return send(res,400,{ok:false,error:'licenseId and hardwareId required'});const s=await state();const d=decision(s,licenseId,hardwareId);if(d.blocked)return send(res,403,{ok:false,blocked:true,reason:d.reason,sequence:s.sequence||0});return send(res,200,{ok:true,blocked:false,licenseId,hardwareId,sequence:s.sequence||0,checkedAt:new Date().toISOString()});}return send(res,404,{ok:false,error:'not_found'});}catch(e){return send(res,503,{ok:false,error:'license_service_unavailable',detail:String(e?.message||e)});}}
