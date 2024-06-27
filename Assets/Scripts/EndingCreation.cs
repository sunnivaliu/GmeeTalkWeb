using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using UnityEngine;

public class EndingCreation : MonoBehaviour
{
    public static GameObject FeedbackObject;
    public static GameObject FeedbackTitleObject;
    public static InputField FeedbackField;

    void Start()
    {
        FeedbackObject = GameObject.FindGameObjectWithTag("Input-Feedback");
        FeedbackTitleObject = GameObject.FindGameObjectWithTag("Input-FeedbackTitle");
        FeedbackField = GameObject.FindGameObjectWithTag("Input-Feedback").GetComponent<InputField>();
        FeedbackObject.SetActive(false);
        FeedbackTitleObject.SetActive(false);
        //GenerateFeedback(CreatePromptings.SystemPrompt); //Debug
    }

    public static void HideFeedback()
    {
        FeedbackField.text = "";
        FeedbackObject.SetActive(false);
        FeedbackTitleObject.SetActive(false);
    }

    public static void GenerateFeedback(string Words)
    {
        FeedbackField.text = Words;
        FeedbackObject.SetActive(true);
        FeedbackTitleObject.SetActive(true);

    }

    public static void checkEnding(string message)
    {
        if (message.Contains("1/5")|| message.Contains("2/5") || message.Contains("3/5") || message.Contains("4/5") || message.Contains("5/5"))
        {
            GenerateFeedback(message);
        }
    }

    private void OnDestroy()
    {
        FeedbackField.text = "";
    }

}
