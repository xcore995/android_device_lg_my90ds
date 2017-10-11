/*
 *
 * Copyright (C) 2017 The LineageOS Project
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.android.internal.telephony;

import static com.android.internal.telephony.RILConstants.*;

import com.android.internal.telephony.uicc.IccRefreshResponse;
import android.content.Context;
import android.os.AsyncResult;
import android.os.Message;
import android.os.Parcel;
import android.telephony.Rlog;

public class SproutRIL extends RIL implements CommandsInterface {

    static final int RIL_REQUEST_DUAL_SIM_MODE_SWITCH = 2012;
    static final int RIL_REQUEST_SET_GPRS_CONNECT_TYPE = 2016;
    static final int RIL_REQUEST_SET_GPRS_TRANSFER_TYPE = 2017;
    static final int RIL_REQUEST_SET_CALL_INDICATION = 2036;
    static final int RIL_UNSOL_NEIGHBORING_CELL_INFO = 3000;
    static final int RIL_UNSOL_NETWORK_INFO = 3001;
    static final int RIL_UNSOL_CALL_FORWARDING = 3002;
    static final int RIL_UNSOL_CRSS_NOTIFICATION = 3003;
    static final int RIL_UNSOL_CALL_PROGRESS_INFO = 3004;
    static final int RIL_UNSOL_PHB_READY_NOTIFICATION = 3005;
    static final int RIL_UNSOL_SPEECH_INFO = 3006;
    static final int RIL_UNSOL_SIM_INSERTED_STATUS = 3007;
    static final int RIL_UNSOL_RADIO_TEMPORARILY_UNAVAILABLE = 3008;
    static final int RIL_UNSOL_ME_SMS_STORAGE_FULL = 3009;
    static final int RIL_UNSOL_SMS_READY_NOTIFICATION = 3010;
    static final int RIL_UNSOL_SCRI_RESULT = 3011;
    static final int RIL_UNSOL_VT_STATUS_INFO = 3012;
    static final int RIL_UNSOL_VT_RING_INFO = 3013;
    static final int RIL_UNSOL_INCOMING_CALL_INDICATION = 3014;
    static final int RIL_UNSOL_SIM_MISSING = 3015;
    static final int RIL_UNSOL_GPRS_DETACH = 3016;
    static final int RIL_UNSOL_SIM_RECOVERY= 3018;
    static final int RIL_UNSOL_VIRTUAL_SIM_ON = 3019;
    static final int RIL_UNSOL_VIRTUAL_SIM_OFF = 3020;
    static final int RIL_UNSOL_INVALID_SIM = 3021;
    static final int RIL_UNSOL_RESPONSE_PS_NETWORK_STATE_CHANGED = 3022;
    static final int RIL_UNSOL_RESPONSE_ACMT = 3023;
    static final int RIL_UNSOL_EF_CSP_PLMN_MODE_BIT = 3024;
    static final int RIL_UNSOL_IMEI_LOCK = 3025;
    static final int RIL_UNSOL_RESPONSE_MMRR_STATUS_CHANGED = 3026;
    static final int RIL_UNSOL_SIM_PLUG_OUT = 3027;
    static final int RIL_UNSOL_SIM_PLUG_IN = 3028;
    static final int RIL_UNSOL_RESPONSE_ETWS_NOTIFICATION = 3029;
    static final int RIL_UNSOL_CNAP = 3030;
    static final int RIL_UNSOL_STK_EVDL_CALL = 3031;

    private boolean dataAllowed = false;
    private boolean setPreferredNetworkTypeSeen = false;
    private String voiceRegState = "0";
    private String voiceDataTech = "0";

    public SproutRIL(Context context, int preferredNetworkType, int cdmaSubscription, Integer instanceId) {
	    super(context, preferredNetworkType, cdmaSubscription, instanceId);
    }

    @Override
    public void setInitialAttachApn(String apn, String protocol, int authType, String username,
             String password, Message result) {
        riljLog("setInitialAttachApn");

        dataAllowed = true; //If we should attach to an APN, we actually need to register data

        riljLog("Faking VoiceNetworkState");
        mVoiceNetworkStateRegistrants.notifyRegistrants(new AsyncResult(null, null, null));

        if (result != null) {
            AsyncResult.forMessage(result, null, null);
            result.sendToTarget();
         }
    }

    @Override
    protected RILRequest
    processSolicited (Parcel p, int type) {
        int serial, error, request;
        RILRequest rr;
        int dataPosition = p.dataPosition(); // save off position within the Parcel

        serial = p.readInt();
        error = p.readInt();

        rr = mRequestList.get(serial);
        if (rr == null || error != 0 || p.dataAvail() <= 0) {
            p.setDataPosition(dataPosition);
            return super.processSolicited(p, type);
        }

        try { switch (rr.mRequest) {
           case RIL_REQUEST_VOICE_REGISTRATION_STATE:
               String voiceRegStates[] = (String [])responseStrings(p);

               riljLog("VoiceRegistrationState response");

               if (voiceRegStates.length > 0 && voiceRegStates[0] != null) {
                   voiceRegState = voiceRegStates[0];
               }

               if (voiceRegStates.length > 3 && voiceRegStates[3] != null) {
                   voiceDataTech = voiceRegStates[3];
               }

               if (RILJ_LOGD) riljLog(rr.serialString() + "< " + requestToString(rr.mRequest)
                               + " " + retToString(rr.mRequest, voiceRegStates));

               if (rr.mResult != null) {
                       AsyncResult.forMessage(rr.mResult, voiceRegStates, null);
                       rr.mResult.sendToTarget();
               }
               mRequestList.remove(serial);
               break;
           case RIL_REQUEST_DATA_REGISTRATION_STATE:
               String dataRegStates[] = (String [])responseStrings(p);

               riljLog("DataRegistrationState response");

               if (dataRegStates.length > 0) {
                   if (dataRegStates[0] != null) {
                       if (!dataAllowed) {
                           if (Integer.parseInt(dataRegStates[0]) > 0) {
                               riljLog("Modifying dataRegState to 0 from " + dataRegStates[0]);
                               dataRegStates[0] = "0";
                           }
                       } else {
                           if ((Integer.parseInt(dataRegStates[0]) != 1) && (Integer.parseInt(dataRegStates[0]) != 5) &&
                               ((Integer.parseInt(voiceRegState) == 1) || (Integer.parseInt(voiceRegState) == 5))) {
                               riljLog("Modifying dataRegState from " + dataRegStates[0] + " to " + voiceRegState);
                               dataRegStates[0] = voiceRegState;
                               if (dataRegStates.length > 3) {
                                   riljLog("Modifying dataTech from " + dataRegStates[3] + " to " + voiceDataTech);
                                   dataRegStates[3] = voiceDataTech;
                               }
                           }
                       }
                   }
               }

               if (RILJ_LOGD) riljLog(rr.serialString() + "< " + requestToString(rr.mRequest)
                               + " " + retToString(rr.mRequest, dataRegStates));

               if (rr.mResult != null) {
                       AsyncResult.forMessage(rr.mResult, dataRegStates, null);
                       rr.mResult.sendToTarget();
               }
               mRequestList.remove(serial);
               break;
           default:
               p.setDataPosition(dataPosition);
               return super.processSolicited(p, type);
        }} catch (Throwable tr) {
                // Exceptions here usually mean invalid RIL responses

                Rlog.w(RILJ_LOG_TAG, rr.serialString() + "< "
                                + requestToString(rr.mRequest)
                                + " exception, possible invalid RIL response", tr);

                if (rr.mResult != null) {
                        AsyncResult.forMessage(rr.mResult, null, tr);
                        rr.mResult.sendToTarget();
                }
                return rr;
        }

        return rr;
    }

    @Override
    protected void
    processUnsolicited (Parcel p, int type) {
        Object ret;
        int dataPosition = p.dataPosition();
        int response = p.readInt();

        switch(response) {
            case RIL_UNSOL_CALL_PROGRESS_INFO: ret = responseStrings(p); break;
            case RIL_UNSOL_INCOMING_CALL_INDICATION: ret = responseStrings(p); break;
            case RIL_UNSOL_RESPONSE_PS_NETWORK_STATE_CHANGED: ret =  responseVoid(p); break;
            case RIL_UNSOL_SIM_INSERTED_STATUS: ret = responseInts(p); break;
            case RIL_UNSOL_SIM_MISSING: ret = responseInts(p); break;
            case RIL_UNSOL_SIM_PLUG_OUT: ret = responseInts(p); break;
            case RIL_UNSOL_SIM_PLUG_IN: ret = responseInts(p); break;
            case RIL_UNSOL_SMS_READY_NOTIFICATION: ret = responseVoid(p); break;
            case RIL_UNSOL_RESPONSE_RADIO_STATE_CHANGED: ret =  responseVoid(p); break;
            default:
                p.setDataPosition(dataPosition);
                super.processUnsolicited(p, type);
                return;
        }

        // To avoid duplicating code from RIL.java, we rewrite some response codes to fit
        // AOSP's one (when they do the same effect)
        boolean rewindAndReplace = false;
        int newResponseCode = 0;

        switch (response) {
            case RIL_UNSOL_CALL_PROGRESS_INFO:
		rewindAndReplace = true;
		newResponseCode = RIL_UNSOL_RESPONSE_CALL_STATE_CHANGED;
		break;
            case RIL_UNSOL_INCOMING_CALL_INDICATION:
		setCallIndication((String[])ret);
                rewindAndReplace = true;
		newResponseCode = RIL_UNSOL_RESPONSE_CALL_STATE_CHANGED;
		break;
            case RIL_UNSOL_RESPONSE_PS_NETWORK_STATE_CHANGED:
                rewindAndReplace = true;
                newResponseCode = RIL_UNSOL_RESPONSE_VOICE_NETWORK_STATE_CHANGED;
                break;
            case RIL_UNSOL_SIM_INSERTED_STATUS:
            case RIL_UNSOL_SIM_MISSING:
            case RIL_UNSOL_SIM_PLUG_OUT:
            case RIL_UNSOL_SIM_PLUG_IN:
                rewindAndReplace = true;
                newResponseCode = RIL_UNSOL_RESPONSE_SIM_STATUS_CHANGED;
                break;
            case RIL_UNSOL_SMS_READY_NOTIFICATION:
                break;
            case RIL_UNSOL_RESPONSE_RADIO_STATE_CHANGED:
		// intercept and send GPRS_TRANSFER_TYPE and GPRS_CONNECT_TYPE to RIL
	        setRadioStateFromRILInt(p.readInt());
		rewindAndReplace = true;
		newResponseCode = RIL_UNSOL_RESPONSE_RADIO_STATE_CHANGED;
		break;
            default:
                Rlog.i(RILJ_LOG_TAG, "Unprocessed unsolicited known MTK response: " + response);
        }

        if (rewindAndReplace) {
            Rlog.w(RILJ_LOG_TAG, "Rewriting MTK unsolicited response to " + newResponseCode);

            // Rewrite
            p.setDataPosition(dataPosition);
            p.writeInt(newResponseCode);

            // And rewind again in front
            p.setDataPosition(dataPosition);

            super.processUnsolicited(p, type);
        }
    }    

    private void setCallIndication(String[] incomingCallInfo) {

	RILRequest rr = RILRequest.obtain(RIL_REQUEST_SET_CALL_INDICATION, null);

	int callId = Integer.parseInt(incomingCallInfo[0]);
        int callMode = Integer.parseInt(incomingCallInfo[3]);
        int seqNumber = Integer.parseInt(incomingCallInfo[4]);

	// some guess work is needed here, for now, just 0
	callMode = 0;

        rr.mParcel.writeInt(3);

        rr.mParcel.writeInt(callMode);
        rr.mParcel.writeInt(callId);
        rr.mParcel.writeInt(seqNumber);

        if (RILJ_LOGD) riljLog(rr.serialString() + "> "
            + requestToString(rr.mRequest) + " " + callMode + " " + callId + " " + seqNumber);

        send(rr);
    }

    // Override setupDataCall as the MTK RIL needs 8th param CID (hardwired to 1?)
    @Override
    protected Object
    responseSimRefresh(Parcel p) {
        IccRefreshResponse response = new IccRefreshResponse();

        response.refreshResult = p.readInt();
        String rawefId = p.readString();
        response.efId   = rawefId == null ? 0 : Integer.parseInt(rawefId);
        response.aid = p.readString();

        return response;
    }

    @Override
    public void
    setupDataCall(int radioTechnology, int profile, String apn,
            String user, String password, int authType, String protocol,
            Message result) {

        RILRequest rr = RILRequest.obtain(RIL_REQUEST_SETUP_DATA_CALL, result);

        rr.mParcel.writeInt(8);

        rr.mParcel.writeString(Integer.toString(radioTechnology + 2));
        rr.mParcel.writeString(Integer.toString(profile));
        rr.mParcel.writeString(apn);
        rr.mParcel.writeString(user);
        rr.mParcel.writeString(password);
        rr.mParcel.writeString(Integer.toString(authType));
        rr.mParcel.writeString(protocol);
        rr.mParcel.writeString("1");

        if (RILJ_LOGD) riljLog(rr.serialString() + "> "
                + requestToString(rr.mRequest) + " " + radioTechnology + " "
                + profile + " " + apn + " " + user + " "
                + password + " " + authType + " " + protocol + "1");

        send(rr);
    }

    private void setRadioStateFromRILInt (int stateCode) {
        switch (stateCode) {
	case 0: case 1: break; // radio off
	default:
	    {
	        RILRequest rr = RILRequest.obtain(RIL_REQUEST_SET_GPRS_TRANSFER_TYPE, null);

		if (RILJ_LOGD) riljLog(rr.serialString() + "> " + requestToString(rr.mRequest));

		rr.mParcel.writeInt(1);
		rr.mParcel.writeInt(1);

		send(rr);
	    }
	    {
	        RILRequest rr = RILRequest.obtain(RIL_REQUEST_SET_GPRS_CONNECT_TYPE, null);

		if (RILJ_LOGD) riljLog(rr.serialString() + "> " + requestToString(rr.mRequest));

		rr.mParcel.writeInt(1);
		rr.mParcel.writeInt(1);

		send(rr);
	    }
	}
    }

    @Override
    public void getRadioCapability(Message response) {
        riljLog("getRadioCapability: returning static radio capability");
        if (response != null) {
            Object ret = makeStaticRadioCapability();
            AsyncResult.forMessage(response, ret, null);
            response.sendToTarget();
        }
    }

    protected Object
    responseFailCause(Parcel p) {
        int numInts;
        int response[];

        numInts = p.readInt();
        response = new int[numInts];
        for (int i = 0 ; i < numInts ; i++) {
            response[i] = p.readInt();
        }
        LastCallFailCause failCause = new LastCallFailCause();
        failCause.causeCode = response[0];
        if (p.dataAvail() > 0) {
          failCause.vendorCause = p.readString();
        }
        return failCause;
    }

    @Override
    public void setPreferredNetworkType(int networkType , Message response) {
        riljLog("setPreferredNetworkType: " + networkType);

        if (!setPreferredNetworkTypeSeen) {
            setPreferredNetworkTypeSeen = true;
        }

        super.setPreferredNetworkType(networkType, response);
    }
	
	
	    @Override
    public void
    iccIOForApp (int command, int fileid, String path, int p1, int p2, int p3,
            String data, String pin2, String aid, Message result) {
        if (command == 0xc0 && p3 == 0) {
            Rlog.i("MT6735", "Override the size for the COMMAND_GET_RESPONSE 0 => 15");
            p3 = 15;
        }
        super.iccIOForApp(command, fileid, path, p1, p2, p3, data, pin2, aid, result);
    }

}
