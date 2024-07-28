using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using UnityEngine;

public class EndingCreation : MonoBehaviour
{
    [SerializeField] private Button copyButton;

    public static GameObject FeedbackObject;
    public static GameObject FeedbackTitleObject;
    public static GameObject FeedbackField;
    public static ScrollRect scroll;

    void Start()
    {
        FeedbackTitleObject = GameObject.FindGameObjectWithTag("Input-FeedbackTitle");
        FeedbackObject = GameObject.FindGameObjectWithTag("Input-Feedback");
        FeedbackField = GameObject.FindGameObjectWithTag("Input-FeedbackText");
        scroll = GameObject.FindGameObjectWithTag("Scroll-Feedback").GetComponent<ScrollRect>();
        copyButton.onClick.AddListener(CopyToClipboard);

        FeedbackObject.SetActive(false);
        FeedbackTitleObject.SetActive(false);


    }

    public static void HideFeedback()
    {
        FeedbackField.GetComponent<TMPro.TextMeshProUGUI>().text = "";
        FeedbackObject.SetActive(false);
        FeedbackTitleObject.SetActive(false);
    }

    public static void GenerateFeedback(string Words)
    {
        FeedbackField.GetComponent<TMPro.TextMeshProUGUI>().text = Words;
        PushToCanvas(Words);

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
        FeedbackField.GetComponent<TMPro.TextMeshProUGUI>().text = "";
    }

    private void CopyToClipboard()
    {
        GUIUtility.systemCopyBuffer = FeedbackField.GetComponent<TMPro.TextMeshProUGUI>().text;
    }

    public static void PushToCanvas(string result)
    {
        // Reset the content size
        scroll.content.SetSizeWithCurrentAnchors(RectTransform.Axis.Vertical, 0);
        TMPro.TextMeshProUGUI textComponent = FeedbackField.GetComponent<TMPro.TextMeshProUGUI>();
        textComponent.text = result;
        LayoutRebuilder.ForceRebuildLayoutImmediate(textComponent.rectTransform); //update size

        // Calculate new height based on text size
        float height = Mathf.Min(scroll.viewport.rect.height,textComponent.GetPreferredValues().y);
        Debug.Log("height" + height);
        scroll.content.SetSizeWithCurrentAnchors(RectTransform.Axis.Vertical, height);
        scroll.verticalNormalizedPosition = 1;
    }


}
