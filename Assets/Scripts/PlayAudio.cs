using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using UnityEngine.Networking;

namespace OpenAI
{
    public class PlayAudio : MonoBehaviour
    {
        public GameObject audioObject;
        private AudioSource audioSource;

        void Start()
        {
            audioSource = audioObject.GetComponent<AudioSource>();
            if (audioSource.clip == null) { Debug.Log("Audio source is null"); }
            Debug.Log("path: " + Directory.GetParent(Application.dataPath).FullName);
        }

        private class TTSPayload
        {
            public string model;
            public string input;
            public string voice;
            public string response_format;
            public float speed;
        }

        public void TurnReplyToAudio(string ResponseText)
        {
            TextToAudio(ResponseText);
        }

        private async void TextToAudio(string ResponseText)
        {
            byte[] audioData = await SendRequest(ResponseText);
            if (audioData != null)
            {
                Debug.Log("Audio data received. " + audioData[0] + audioData[10]);
                PlayResponse(audioData);
                
                //AudioClip audioClip = Inworld.WavUtilityFromInworld.ToAudioClip(audioData);
                //if (audioClip != null)
                //{
                //    audioSource.clip = audioClip;
                //    audioSource.Play();
                //    Debug.Log("Playing audio.");
                //}
            }

            else
            {
                Debug.LogError("Failed to receive audio data.");
            }
        }


        private async Task<byte[]> SendRequest(string ResponseText)
        {
            Debug.Log("Sending new request to OpenAI TTS. " + ResponseText);
            TTSPayload payload = new TTSPayload
            {
                model = "tts-1",
                input = ResponseText,
                voice = "alloy",
                response_format = "mp3",
                speed = 1f
            };
            string jsonPayload = JsonUtility.ToJson(payload);
            UnityWebRequest request = new UnityWebRequest("https://api.openai.com/v1/audio/speech", "POST");

            byte[] bodyRaw = Encoding.UTF8.GetBytes(jsonPayload);
            request.uploadHandler = new UploadHandlerRaw(bodyRaw);
            request.downloadHandler = new DownloadHandlerBuffer();
            request.SetRequestHeader("Content-Type", "application/json");
            request.SetRequestHeader("Authorization", "Bearer " + "sk-proj-XU2mdapkeng3A4BY13AET3BlbkFJh8S0TB8fonhSFyTTSi8D"); //API KEY

            await request.SendWebRequest();

            if (request.result == UnityWebRequest.Result.ConnectionError || request.result == UnityWebRequest.Result.ProtocolError)
            {
                Debug.LogError("Error: " + request.error);
                return null;
            }
            else
            {
                return request.downloadHandler.data;
            }

        }

        private void PlayResponse(byte[] audioData)
        {
            if (audioData != null)
            {
                string filePath = Path.Combine(Path.Combine(Application.persistentDataPath + "/audio.mp3")); //Application.persistentDataPath Directory.GetParent(Application.dataPath).FullName
                Debug.Log("Audio filePath: " + filePath);
                File.WriteAllBytes(filePath, audioData);
                LoadAndPlayAudio(audioData, filePath);
            }
            else Debug.LogError("audioData is NULL");
        }

        private async void LoadAndPlayAudio(byte[] audioData, string filePath) 
        {
            //audioDataFloat = ConvertByteToFloat(audioData);
            //Debug.Log("audioDataFloat.Length " + audioDataFloat.Length + "-" + audioDataFloat[0] + audioDataFloat[1]);
            //audioSource.clip.GetData(audioDataFloat, 0);
            //audioSource.clip.SetData(audioDataFloat, 0);
            //audioSource.Play();

            using UnityWebRequest www = UnityWebRequestMultimedia.GetAudioClip("file://" + filePath, AudioType.MPEG);
            await www.SendWebRequest();

            if (www.result == UnityWebRequest.Result.ConnectionError || www.result == UnityWebRequest.Result.ProtocolError)
            {
                Debug.LogError("Error: " + www.error);
            }

            if (www.result == UnityWebRequest.Result.Success)
            {
                AudioClip audioClip = DownloadHandlerAudioClip.GetContent(www);
                audioSource = audioObject.GetComponent<AudioSource>();
                audioSource.clip = audioClip;
                audioSource.Play();
            }
            else Debug.LogError("Audio file loading error: " + www.error);
        }

        private float[] ConvertByteToFloat(byte[] byteArray)
        {
            int sampleCount = byteArray.Length / 2; // Assuming 16-bit audio
            float[] floatArray = new float[sampleCount];
            for (int i = 0; i < sampleCount; i++)
            {
                short value = BitConverter.ToInt16(byteArray, i * 2);
                floatArray[i] = value / 32768.0f;
            }
            return floatArray;
        }

    }
}






////Net does not work in WebGL
///using System.Net.Http.Headers;
//private async Task<byte[]> RequestTextToSpeech(string ResponseText, float speed = 1f)
//{
//    Debug.Log("Sending new request to OpenAI TTS. " + ResponseText);
//    using var httpClient = new HttpClient();
//    httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", "sk-proj-XU2mdapkeng3A4BY13AET3BlbkFJh8S0TB8fonhSFyTTSi8D");

//    TTSPayload payload = new TTSPayload
//    {
//        model = "tts-1",
//        input = ResponseText,
//        voice = "alloy",
//        response_format = "mp3",
//        speed = speed
//    };

//    string jsonPayload = JsonUtility.ToJson(payload);

//    var httpResponse = await httpClient.PostAsync(
//        "https://api.openai.com/v1/audio/speech",
//        new StringContent(jsonPayload, Encoding.UTF8, "application/json")
//    );

//    byte[] audioD = await httpResponse.Content.ReadAsByteArrayAsync();
//    if (httpResponse.IsSuccessStatusCode) return audioD;

//    Debug.Log("Error: " + httpResponse.StatusCode);
//    return null;
//}

